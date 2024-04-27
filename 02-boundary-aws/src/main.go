package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/hashicorp/boundary/api"
	"github.com/hashicorp/boundary/api/authmethods"
	"github.com/hashicorp/boundary/api/roles"
)

// CloudWatchAlarmEvent represents the trigger payload from the CloudWatch Alarm
type CloudWatchAlarmEvent struct {
	AlarmData AlarmDataPayload `json:"alarmData"`
}

// AlarmDataPayload contains the data related to the actual alarm
type AlarmDataPayload struct {
	State AlarmState `json:"state"`
}

// AlarmState represents the new state of the alarm that have triggered the function
type AlarmState struct {
	Value string `json:"value"`
}

// CreateBoundaryClient authenticates the Boundary client using the password auth method
func CreateBoundaryClient() (*api.Client, error) {
	client, err := api.NewClient(&api.Config{Addr: os.Getenv("BOUNDARY_ADDR")})
	if err != nil {
		return nil, err
	}

	credentials := map[string]interface{}{
		"login_name": os.Getenv("BOUNDARY_USERNAME"),
		"password":   os.Getenv("BOUNDARY_PASSWORD"),
	}

	authMethodClient := authmethods.NewClient(client)
	authenticationResult, err := authMethodClient.Authenticate(context.Background(), os.Getenv("BOUNDARY_AUTH_METHOD_ID"), "login", credentials)
	if err != nil {
		return nil, err
	}

	client.SetToken(fmt.Sprint(authenticationResult.Attributes["token"]))

	return client, nil
}

// AssignOnCallRole assigns the on-call role to the on-call group in Boundary
func AssignOnCallRole(c *api.Client) error {
	rolesClient := roles.NewClient(c)
	role, err := rolesClient.Read(context.Background(), os.Getenv("BOUNDARY_ON_CALL_ROLE_ID"))
	if err != nil {
		return err
	}

	for _, principalId := range role.Item.PrincipalIds {
		if principalId == os.Getenv("BOUNDARY_ON_CALL_GROUP_ID") {
			return nil
		}
	}

	_, err = rolesClient.AddPrincipals(context.Background(), os.Getenv("BOUNDARY_ON_CALL_ROLE_ID"), role.Item.Version, []string{os.Getenv("BOUNDARY_ON_CALL_GROUP_ID")})
	if err != nil {
		log.Println(err)
		return err
	}

	return nil
}

// RevokeOnCallRole revokes the on-call role from the on-call group in Boundary
func RevokeOnCallRole(c *api.Client) error {
	rolesClient := roles.NewClient(c)
	role, err := rolesClient.Read(context.Background(), os.Getenv("BOUNDARY_ON_CALL_ROLE_ID"))
	if err != nil {
		return err
	}

	for _, principalId := range role.Item.PrincipalIds {
		if principalId == os.Getenv("BOUNDARY_ON_CALL_GROUP_ID") {
			_, err := rolesClient.RemovePrincipals(context.Background(), os.Getenv("BOUNDARY_ON_CALL_ROLE_ID"), role.Item.Version, []string{os.Getenv("BOUNDARY_ON_CALL_GROUP_ID")})
			if err != nil {
				return err
			}
			return nil
		}
	}

	return nil
}

// HandleAlert is the Lambda function handler function that triggers the correct action based on the alarm
func HandleAlert(ctx context.Context, event CloudWatchAlarmEvent) error {
	if event.AlarmData.State.Value == "INSUFFICIENT_DATA" {
		return nil
	}

	client, err := CreateBoundaryClient()
	if err != nil {
		return errors.Join(errors.New("could not create Boundary client"), err)
	}

	if event.AlarmData.State.Value == "ALARM" {
		err = AssignOnCallRole(client)
		if err != nil {
			return errors.Join(errors.New("could not assign role to user"), err)
		}
	}

	if event.AlarmData.State.Value == "OK" {
		err = RevokeOnCallRole(client)
		if err != nil {
			return errors.Join(errors.New("could not revoke role from user"), err)
		}
	}

	return nil
}

func main() {
	lambda.Start(HandleAlert)
}

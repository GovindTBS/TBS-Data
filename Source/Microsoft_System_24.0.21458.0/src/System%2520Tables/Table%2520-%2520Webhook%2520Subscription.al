// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000199 "Webhook Subscription"
{
    Caption = 'Webhook Subscription';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Subscription ID"; Text[150])
        {
            Caption = 'Subscription ID';
        }
        field(2; Endpoint; Text[250])
        {
            Caption = 'Endpoint';
        }
        field(3; "Client State"; Text[50])
        {
            Caption = 'Client State';
        }
        field(4; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(5; "Run Notification As"; Guid)
        {
            Caption = 'Run Notification As';
        }
        field(6; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(7; "Application ID"; Text[20])
        {
            Caption = 'Application ID';
        }
    }

    keys
    {
        key(Key1; "Subscription ID", Endpoint)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


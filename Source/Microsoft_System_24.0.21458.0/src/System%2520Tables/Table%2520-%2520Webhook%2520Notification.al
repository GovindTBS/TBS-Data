// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000194 "Webhook Notification"
{
    Caption = 'Webhook Notification';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; "Sequence Number"; Integer)
        {
            Caption = 'Sequence Number';
        }
        field(3; "Subscription ID"; Text[150])
        {
            Caption = 'Subscription ID';
        }
        field(4; "Resource ID"; Text[250])
        {
            Caption = 'Resource ID';
        }
        field(5; "Change Type"; Text[50])
        {
            Caption = 'Change Type';
        }
        field(6; "Resource Type Name"; Text[250])
        {
            Caption = 'Resource Type Name';
        }
        field(7; Notification; BLOB)
        {
            Caption = 'Notification';
            SubType = Json;
        }
    }

    keys
    {
        key(Key1; ID, "Resource Type Name", "Sequence Number", "Subscription ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


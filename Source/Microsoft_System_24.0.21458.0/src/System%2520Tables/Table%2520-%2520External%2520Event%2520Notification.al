// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000242 "External Event Notification"
{
    Caption = 'External Event Notification';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Log Entry Id"; Integer)
        {
            Caption = 'Log Entry Id';
            TableRelation = "External Event Log Entry".ID;
        }
        field(2; "Subscription Id"; Guid)
        {
            Caption = 'Subscription Id';
            TableRelation = "External Event Subscription".ID;
        }
        field(3; "Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,Sent,Failed';
            OptionMembers = Pending,Sent,Failed;
        }
        field(4; "Last Retry Date Time"; DateTime)
        {
            Caption = 'Last Retry Date Time';
        }
        field(5; "Retry Count"; Integer)
        {
            Caption = 'Retry Count';
        }
        field(6; "Not Before"; DateTime)
        {
            Caption = 'Not Before';
        }
    }

    keys
    {
        key(Key1; "Log Entry Id", "Subscription Id")
        {
            Clustered = true;
        }
        key(Key2; "Status", "Not Before", "Subscription Id")
        {
        }
        key(Key3; "Status", "Last Retry Date Time")
        {
        }
        key(Key4; "Log Entry Id")
        {
        }

        key(Key5; "Status")
        {
        }

        key(Key6; "Subscription Id", "SystemCreatedAt", "Status")
        {
        }
    }

    fieldgroups
    {
    }
}


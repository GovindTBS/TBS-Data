// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000245 "External Event Activity Log"
{
    Caption = 'External Event Activity Log';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    InherentEntitlements = RI;

    fields
    {
        field(1; "Id"; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2; "Notification Url"; Text[2048])
        {
            Caption = 'Notification Url';
        }
        field(3; "Subscription Id"; Guid)
        {
            Caption = 'Subscription Id';
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Success,Failed';
            OptionMembers = Success,Failed;
        }
        field(5; "Activity Message"; Text[250])
        {
            Caption = 'Activity Message';
        }
    }

    keys
    {
        key(Key1; "Id")
        {
            Clustered = true;
        }
        key(Key2; "SystemCreatedAt", "Id")
        {
        }
    }

    fieldgroups
    {
    }
}


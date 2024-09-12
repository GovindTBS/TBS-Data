// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

using System.Security.AccessControl;

table 2000000096 "API Webhook Notification"
{
    Caption = 'API Webhook Notification';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; "Subscription ID"; Text[150])
        {
            Caption = 'Subscription ID';
        }
        field(3; "Created By User SID"; Guid)
        {
            DataClassification = EndUserPseudonymousIdentifiers;
            Caption = 'Created By User SID';
            TableRelation = User."User Security ID";
        }
        field(4; "Entity Key Value"; Text[250])
        {
            Caption = 'Entity Key Value';
        }
        field(5; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
        }
        field(6; "Change Type"; Option)
        {
            Caption = 'Change Type';
            OptionCaption = 'Created,Updated,Deleted,Collection';
            OptionMembers = Created,Updated,Deleted,Collection;
        }
        field(9; "Entity ID"; Guid)
        {
            Caption = 'Entity ID';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Subscription ID")
        {
        }
        key(Key3; "Last Modified Date Time")
        {
        }
    }

    fieldgroups
    {
    }
}


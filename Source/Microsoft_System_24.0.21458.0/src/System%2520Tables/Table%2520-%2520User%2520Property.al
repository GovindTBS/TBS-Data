// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000121 "User Property"
{
    Caption = 'User Property';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    InherentPermissions = rX;

    fields
    {
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            TableRelation = User."User Security ID";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(2; Password; Text[80])
        {
            Caption = 'Password';
        }
        field(3; "Name Identifier"; Text[250])
        {
            Caption = 'Name Identifier';
        }
        field(4; "Authentication Key"; Text[80])
        {
            Caption = 'Authentication Key';
        }
        field(5; "WebServices Key"; Text[80])
        {
            Caption = 'WebServices Key';
        }
        field(6; "WebServices Key Expiry Date"; DateTime)
        {
            Caption = 'WebServices Key Expiry Date';
        }
        field(7; "Authentication Object ID"; Text[80])
        {
            Caption = 'Authentication Object ID';
        }
        field(8; "Directory Role ID"; Text[80])
        {
            Caption = 'Directory Role ID';
            ObsoleteReason = 'This field is deprecated in favour of the "Directory Role ID List" field.';
            ObsoleteState = Removed;
        }
        field(9; "Directory Role ID List"; BLOB)
        {
            Caption = 'Directory Role ID List';
        }
        field(10; "Telemetry User ID"; Guid)
        {
            Caption = 'Telemetry User ID';
        }
    }

    keys
    {
        key(Key1; "User Security ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


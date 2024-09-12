// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

table 2000000200 "NAV App Tenant Operation"
{
    Caption = 'NAV App Tenant Operation';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Operation ID"; Guid)
        {
            Caption = 'Operation ID';
        }
        field(2; "Started On"; DateTime)
        {
            Caption = 'Started On';
        }
        field(3; "Operation Type"; Option)
        {
            Caption = 'Operation Type';
            OptionCaption = 'DeployTarget,DeployPackage';
            OptionMembers = DeployTarget,DeployPackage;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Unknown,InProgress,Failed,Completed,NotFound';
            OptionMembers = Unknown,InProgress,Failed,Completed,NotFound;
        }
        field(5; Details; BLOB)
        {
            Caption = 'Details';
        }
        field(6; "Metadata Version"; Integer)
        {
            Caption = 'Metadata Version';
        }
        field(7; Metadata; BLOB)
        {
            Caption = 'Metadata';
        }
        field(8; "Metadata Key"; Text[250])
        {
            Caption = 'Metadata Key';
        }
        field(9; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Operation ID")
        {
            Clustered = true;
        }
        key(Key2; "Operation Type", "Metadata Key")
        {
        }
    }

    fieldgroups
    {
    }
}


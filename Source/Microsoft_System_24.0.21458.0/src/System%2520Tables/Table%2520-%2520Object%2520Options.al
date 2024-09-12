// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000196 "Object Options"
{
    Caption = 'Object Options';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "Parameter Name"; Text[50])
        {
            Caption = 'Parameter Name';
        }
        field(2; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,"Report",,,"XMLport",,"Page",,,,,,,,,,,;
            OptionCaption = ',,,Report,,,XMLport,,"Page",,,,,,,,,,,';
        }
        field(4; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = System.Environment.Company.Name;
        }
        field(5; "User Name"; Code[50])
        {
            Caption = 'User Name';
        }
        field(6; "Option Data"; BLOB)
        {
            Caption = 'Option Data';
            SubType = UserDefined;
        }
        field(7; "Public Visible"; Boolean)
        {
            Caption = 'Public Visible';
        }
        field(8; "Temporary"; Boolean)
        {
            Caption = 'Temporary';
        }
        field(9; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
    }

    keys
    {
        key(Key1; "Parameter Name", "Object ID", "Object Type", "User Name", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Parameter Name")
        {
        }
    }
}


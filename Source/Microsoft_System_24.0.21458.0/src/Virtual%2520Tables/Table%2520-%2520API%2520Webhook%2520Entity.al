// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

using System.Reflection;

table 2000000097 "API Webhook Entity"
{
    Caption = 'API Webhook Entity';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; Publisher; Text[40])
        {
        }

        field(2; "Group"; Text[40])
        {
        }

        field(3; "Version"; Text[10])
        {
        }

        field(4; Name; Text[250])
        {
        }

        field(5; "Table No."; Integer)
        {
        }

        field(6; "Table Temporary"; Boolean)
        {
        }

        field(7; "Table Filters"; Blob)
        {
        }

        field(8; "Key Fields"; Text[250])
        {
        }

        field(9; "OData Key Specified"; Boolean)
        {
        }

        field(10; "Object Type"; Option)
        {
            OptionMembers = ,,,,,"Codeunit",,,"Page","Query",,,,,,,,,,;
            OptionCaption = ',,,,,Codeunit,,,Page,Query,,,,,,,,,,';
        }

        field(11; "Object ID"; Integer)
        {
            TableRelation = AllObj."Object ID" where("Object Type" = field("Object Type"));
        }

        field(12; "Package ID"; Guid)
        {
        }
    }

    keys
    {
        key(Key1; Publisher, "Group", "Version", Name)
        {
            Clustered = true;
        }

        key(Key2; "Object Type", "Object ID")
        {
        }

        key(Key3; "Package ID")
        {
        }
    }
}


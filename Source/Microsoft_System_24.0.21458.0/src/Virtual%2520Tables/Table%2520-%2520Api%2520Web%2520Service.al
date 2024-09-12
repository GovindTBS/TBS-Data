// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000193 "Api Web Service"
{
    Caption = 'Api Web Service';
    DataPerCompany = false;
    Scope = Cloud;

    fields
    {
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,,,"Codeunit",,,"Page","Query",,,,,,,,,,;
            OptionCaption = ',,,,,Codeunit,,,Page,Query,,,,,,,,,,';
        }
        field(6; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(9; "Service Name"; Text[250])
        {
            Caption = 'Service Name';
        }
        field(12; Published; Boolean)
        {
            Caption = 'Published';
        }
        field(14; Publisher; Text[40])
        {
            Caption = 'Publisher';
        }
        field(15; Group; Text[40])
        {
            Caption = 'Group';
        }
        field(18; Version; Text[10])
        {
            Caption = 'Version';
        }
        field(21; "Package ID"; GUID)
        {
            Caption = 'Package ID';
        }
    }

    keys
    {
        key(pk; "Object Type", "Object ID", "Service Name", Publisher, Group, Version, "Package ID")
        {
        }
    }
}
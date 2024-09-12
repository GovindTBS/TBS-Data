// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000141 "Table Relations Metadata"
{
    DataPerCompany = False;
    Scope = Cloud;
    InherentPermissions = rX;

    //WriteProtected=True;
    fields
    {
        field(1; "Table ID"; Integer)
        {
        }
        field(2; "Field No."; Integer)
        {
        }
        field(3; "Relation No."; Integer)
        {
        }
        field(4; "Condition No."; Integer)
        {
        }
        field(5; "Related Table ID"; Integer)
        {
        }
        field(6; "Related Field No."; Integer)
        {
        }
        field(7; "Condition Type"; Option)
        {
            OptionMembers = "CONST","FILTER";
        }
        field(8; "Condition Field No."; Integer)
        {
        }
        field(9; "Condition Value"; Text[30])
        {
        }
        field(10; "Test Table Relation"; Boolean)
        {
        }
        field(11; "Validate Table Relation"; Boolean)
        {
        }
        field(12; "Table Name"; Text[30])
        {
        }
        field(13; "Field Name"; Text[30])
        {
        }
        field(14; "Related Table Name"; Text[30])
        {
        }
        field(15; "Related Field Name"; Text[30])
        {
        }
    }
    keys
    {
        key(pk; "Table ID", "Field No.", "Relation No.", "Condition No.")
        {

        }
    }
}
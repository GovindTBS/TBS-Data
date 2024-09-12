// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000001 Object
{
    Scope = OnPrem;

    fields
    {
        field(1; Type; Option)
        {
            OptionMembers = TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber;
        }
        field(2; "Company Name"; Text[30]) //OEMText[30]
        {
            TableRelation = System.Environment.Company.Name;
        }
        field(3; ID; Integer)
        {
        }
        field(4; Name; Text[30]) //OEMText[30]
        {
        }
        field(5; Modified; Boolean)
        {
        }
        field(6; Compiled; Boolean)
        {
        }
        field(7; "BLOB Reference"; Blob)
        {
        }
        field(8; "BLOB Size"; Integer)
        {
        }
        field(9; "DBM Table No."; Integer)
        {
        }
        field(10; Date; Date)
        {
        }
        field(11; Time; Time)
        {
        }
        field(12; "Version List"; Text[248]) //OEMText[248]
        {
        }
        field(20; "Caption"; Text[250])
        {
        }
        field(40; "Locked"; Boolean)
        {
        }
        field(50; "Locked By"; Text[132]) //OEMText[132]
        {
        }
    }

    keys
    {
        key(pk; Type, "Company Name", ID)
        {
        }
        key(fk1; Type, Name)
        {
        }
        key(fk2; "Locked", "Locked By")
        {
        }
    }
}


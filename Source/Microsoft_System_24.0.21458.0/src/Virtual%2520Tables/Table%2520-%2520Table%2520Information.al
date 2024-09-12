// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 2000000028 "Table Information"
{
    DataPerCompany = false;
    Scope = OnPrem;

    //WriteProtected=True;
    fields
    {
        field(1; "Company Name"; Text[30])
        {
        }
        field(2; "Table No."; Integer)
        {
        }
        field(3; "Table Name"; Text[30])
        {
        }
        field(4; "No. of Records"; Integer)
        {
        }
        field(5; "Record Size"; Decimal)
        {
        }
        field(6; "Size (KB)"; Integer)
        {
        }
        field(7; "Compression"; Option)
        {
            OptionMembers = None,Row,Page,Columnstore,"Columnstore Archive";
        }
        field(8; "Data Size (KB)"; Integer)
        {
        }
        field(9; "Index Size (KB)"; Integer)
        {
        }
    }

    keys
    {
        key(pk; "Company Name", "Table No.")
        {

        }
    }
}
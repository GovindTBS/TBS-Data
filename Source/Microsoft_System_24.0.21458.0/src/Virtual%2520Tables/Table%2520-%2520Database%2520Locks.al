// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Diagnostics;

table 2000000154 "Database Locks"
{
    DataPerCompany = false;
    Scope = Cloud;

    //WriteProtected=True;
    fields
    {
        field(1; "Transaction ID"; BigInteger)
        {
        }
        field(2; "Object Name"; Text[250])
        {
        }
        field(3; "Resource Type"; Text[60])
        {
        }
        field(4; "Request Mode"; Option)
        {
            OptionMembers = Shared,Update,Exclusive,"Bulk Update",Unknown;
        }
        field(5; "Request Status"; Option)
        {
            OptionMembers = Granted,Converting,Waiting,Unknown;
        }
        field(6; "User Name"; Text[250])
        {
        }
        field(7; "AL Object Type"; option)
        {
            OptionMembers = TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber;
        }
        field(8; "AL Object Id"; Integer)
        {
        }
        field(9; "AL Method Scope"; Text[250])
        {
        }
        field(10; "SQL Session ID"; Integer)
        {
        }
        field(11; "Session ID"; Integer)
        {
        }
        field(12; "AL Object Name"; Text[250])
        {
        }
        field(13; "AL Object Extension Name"; Text[250])
        {
        }
    }
}
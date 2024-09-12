// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000101 "Debugger Call Stack"
{
    DataPerCompany = False;
    Scope = OnPrem;
    ObsoleteState = Removed;
    ObsoleteReason = 'Support for the classic debugger engine has been removed.';

    //WriteProtected=True;
    fields
    {
        field(1; ID; Integer)
        {
        }
        field(3; "Object Type"; Option)
        {
            OptionCaption = ',Table,,Report,,Codeunit,XMLport,,Page,Query,,,,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
            OptionMembers = ,"Table",,"Report",,"Codeunit","XMLport",,"Page","Query",,,,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
        }
        field(5; "Object ID"; Integer)
        {
            //TableRelation=#2000000001.#3 WHERE (#1=FIELD(3));
        }
        field(7; "Line No."; Integer)
        {
        }
        field(9; "Function Name"; Text[128])
        {
        }
        field(11; "Object Name"; Text[30])
        {
            //CalcFormula=Lookup(#2000000058.#4 WHERE(#1=FIELD(#3),#3=FIELD(#5)));
        }
    }

    keys
    {
        key(pk; ID)
        {

        }
    }
}
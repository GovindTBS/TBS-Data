// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000029 "System Object"
{
    DataPerCompany = false;
    Scope = OnPrem;
    //WriteProtected=True;
    fields
    {
        field(1; "Object Type"; option)
        {
            OptionCaption = 'TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber,,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
            OptionMembers = "TableData","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System","FieldNumber",,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
        }
        field(3; "Object ID"; Integer)
        {
        }
        field(4; "Object Name"; Text[30])
        {
        }
        field(20; "Object Caption"; Text[80])
        {
        }
    }

    keys
    {
        key(pk; "Object Type", "Object ID")
        {
        }
    }
}
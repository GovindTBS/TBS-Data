// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000058 AllObjWithCaption
{
    DataPerCompany = false;
    Scope = Cloud;
    //WriteProtected=True;
    InherentPermissions = rX;

    fields
    {
        field(1; "Object Type"; option)
        {
            OptionMembers = "TableData","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System","FieldNumber",,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
            OptionCaption = 'TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber,,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
        }
        field(3; "Object ID"; Integer)
        {
        }
        field(4; "Object Name"; Text[30])
        {
        }
        field(20; "Object Caption"; Text[249])
        {
        }
        field(30; "Object Subtype"; Text[30])
        {
        }
        field(60; "App Package ID"; Guid)
        {
        }
        field(61; "App Runtime Package ID"; Guid)
        {
        }
    }

    keys
    {
        key(pk; "Object Type", "Object ID")
        {

        }
    }
    fieldGroups
    {
        fieldgroup("DropDown"; "Object ID", "Object Type", "Object Caption")
        {

        }
    }
}
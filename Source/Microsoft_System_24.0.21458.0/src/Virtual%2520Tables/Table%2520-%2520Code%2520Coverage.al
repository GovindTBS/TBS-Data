// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

table 2000000049 "Code Coverage"
{
    DataPerCompany = false;
    Scope = Cloud;
    fields
    {
        field(1; "Object Type"; Option)
        {
            OptionMembers = ,"Table",,"Report",,"Codeunit","XMLport",,"Page","Query",,,,,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
            OptionCaption = ',Table,,Report,,Codeunit,XMLport,,Page,Query,,,,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
        }
        field(2; "Object ID"; Integer)
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Line Type"; Option)
        {
            OptionMembers = Object,"Trigger/Function",Empty,Code;
        }
        field(5; Line; Text[250])
        {
        }
        field(6; "No. of Hits"; Integer)
        {
        }
        field(7; "Code Coverage Status"; Option)
        {
            OptionMembers = NonApplicable,NotCovered,Covered,PartiallyCovered;
            OptionCaption = 'Non Applicable,Not Covered,Covered,Partially Covered';
        }
    }
    keys
    {
        key(pk; "Object Type", "Object ID", "Line No.")
        {
        }
    }
}
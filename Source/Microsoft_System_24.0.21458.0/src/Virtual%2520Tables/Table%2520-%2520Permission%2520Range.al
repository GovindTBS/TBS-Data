// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000044 "Permission Range"
{
    DataPerCompany = false;
    Scope = OnPrem;
    //WriteProtected=True;
    fields
    {
        field(1; "Object Type"; Option)
        {
            OptionCaption = 'TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber,LimitedUsageTableData,,PageExtension,TableExtension,Enum,EnumExtension,Profile,ProfileExtension,PermissionSet,PermissionSetExtension,ReportExtension';
            OptionMembers = "TableData","Table",,"Report",,"Codeunit","XMLport","MenuSuite","Page","Query","System","FieldNumber","LimitedUsageTableData",,"PageExtension","TableExtension","Enum","EnumExtension","Profile","ProfileExtension","PermissionSet","PermissionSetExtension","ReportExtension";
        }
        field(2; Index; Integer)
        {
        }
        field(3; From; Integer)
        {
        }
        field(4; To; Integer)
        {
        }
        field(10; "Read Permission"; Option)
        {
            OptionMembers = " ",Yes,Indirect;
            OptionCaption = ' ,Yes,Indirect';
        }
        field(11; "Insert Permission"; Option)
        {
            OptionMembers = " ",Yes,Indirect;
            OptionCaption = ' ,Yes,Indirect';
        }
        field(12; "Modify Permission"; Option)
        {
            OptionMembers = " ",Yes,Indirect;
            OptionCaption = ' ,Yes,Indirect';
        }
        field(13; "Delete Permission"; Option)
        {
            OptionMembers = " ",Yes,Indirect;
            OptionCaption = ' ,Yes,Indirect';
        }
        field(14; "Execute Permission"; Option)
        {
            OptionMembers = " ",Yes,Indirect;
            OptionCaption = ' ,Yes,Indirect';
        }
        field(15; "Limited Usage Permission"; Option)
        {
            OptionMembers = " ",Included,Excluded,Optional;
            OptionCaption = ' ,Included,Excluded,Optional';
        }
    }

    keys
    {
        key(pk; "Object Type", Index)
        {

        }
    }
}
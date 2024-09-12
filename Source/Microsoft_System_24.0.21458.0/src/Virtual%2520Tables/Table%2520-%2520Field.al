// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000041 "Field"
{
    Scope = Cloud;
    InherentPermissions = rX;

    fields
    {
        field(1; TableNo; Integer)
        {
        }
        field(2; "No."; Integer)
        {
        }
        field(3; TableName; Text[30])
        {
        }
        field(4; FieldName; Text[30])
        {
        }
        field(5; Type; Option)
        {
            OptionMembers = TableFilter,RecordID,OemText,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,Binary,BLOB,Boolean,Integer,OemCode,Option,BigInteger,Duration,GUID,DateTime;
            // This list must stay in sync with NCLOptionMetadataNavTypeField
            OptionOrdinalValues = 4912, 4988, 11519, 11775, 11776, 11797, 12799, 26207, 26208, 31488, 31489, 33791, 33793, 34047, 34559, 35071, 35583, 36095, 36863, 37119, 37375;
        }
        field(6; Len; Integer)
        {
        }
        field(7; Class; Option)
        {
            OptionMembers = Normal,FlowField,FlowFilter;
        }
        field(8; Enabled; Boolean)
        {
        }
        field(9; "Type Name"; Text[30])
        {
        }
        field(10; ExternalName; Text[100])
        {
        }
        field(20; "Field Caption"; Text[80])
        {
        }
        field(21; RelationTableNo; Integer)
        {
        }
        field(22; RelationFieldNo; Integer)
        {
        }
        field(23; SQLDataType; option)
        {
            OptionMembers = Varchar,Integer,Variant,BigInteger;
        }
        field(24; OptionString; Text[2047])
        {
        }
        field(25; ObsoleteState; Option)
        {
            OptionMembers = No,Pending,Removed;
        }
        field(26; ObsoleteReason; Text[248])
        {
        }
        field(27; DataClassification; Option)
        {
            OptionMembers = CustomerContent,ToBeClassified,EndUserIdentifiableInformation,AccountData,EndUserPseudonymousIdentifiers,OrganizationIdentifiableInformation,SystemMetadata;
        }
        field(28; IsPartOfPrimaryKey; Boolean)
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
        key(pk; TableNo, "No.")
        {
        }
    }
}
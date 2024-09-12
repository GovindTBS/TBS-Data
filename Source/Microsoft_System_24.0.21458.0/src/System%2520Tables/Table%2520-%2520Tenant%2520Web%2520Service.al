// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

using System.Reflection;

table 2000000168 "Tenant Web Service"
{
    Caption = 'Tenant Web Service';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(3; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,,,,,"Codeunit",,,"Page","Query",,,,,,,,,,;
            OptionCaption = ',,,,,Codeunit,,,Page,Query,,,,,,,,,,';
        }
        field(6; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = FIELD("Object Type"));
        }
        field(9; "Service Name"; Text[250])
        {
            Caption = 'Service Name';
        }
        field(12; Published; Boolean)
        {
            Caption = 'Published';
        }
        field(13; ExcludeFieldsOutsideRepeater; Boolean)
        {
            Caption = 'Exclude Fields Outside of the Repeater from Etag';
        }
        field(14; ExcludeNonEditableFlowFields; Boolean)
        {
            Caption = 'Exclude Non-Editable Flow Fields from ETag';
        }
    }

    keys
    {
        key(Key1; "Object Type", "Service Name")
        {
            Clustered = true;
        }
        key(Key2; "Object Type", "Object ID")
        {
        }
    }

    fieldgroups
    {
    }
}


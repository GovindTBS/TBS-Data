// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Reflection;

table 2000000187 "Tenant Profile Page Metadata"
{
    Caption = 'Tenant Profile Page Metadata';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Pending;
    ObsoleteReason = 'The table will only contain the page customizations created using the in-client profile configuration and will not contain page customizations from extensions anymore.';
    InherentPermissions = rX;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(2; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
            TableRelation = "Tenant Profile"."Profile ID";
        }
        field(3; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(4; "Page Metadata"; BLOB)
        {
            Caption = 'Page Metadata';
        }
        field(5; "Page AL"; BLOB)
        {
            Caption = 'Page AL';
        }
        field(6; Owner; Option)
        {
            Caption = 'Owner';
            OptionCaption = 'System,Tenant';
            OptionMembers = System,Tenant;
        }
        field(7; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }
    }

    keys
    {
        key(Key1; "Profile ID", "Page ID", "App ID", Owner)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000253 "Tenant Permission Set Rel."
{
    Caption = 'Tenant Permission Set Rel.';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
            TableRelation = "Tenant Permission Set"."App ID";
        }
        field(2; "Role ID"; Code[30])
        {
            Caption = 'Role ID';
            TableRelation = "Tenant Permission Set"."Role ID";
        }
        field(3; "Related App ID"; Guid)
        {
            Caption = 'Related App ID';
            TableRelation = IF ("Related Scope" = CONST(System))
            "Metadata Permission Set"."App ID" WHERE("Role ID" = FIELD("Related Role ID"))
            ELSE
            "Tenant Permission Set"."App ID" WHERE("Role ID" = FIELD("Related Role ID"));
        }
        field(4; "Related Role ID"; Code[30])
        {
            Caption = 'Related Role ID';
            TableRelation = IF ("Related Scope" = CONST(System)) "Metadata Permission Set"."Role ID" ELSE
            "Tenant Permission Set"."Role ID";
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Include,Exclude;
            OptionCaption = 'Include,Exclude';
            InitValue = Include;
        }
        field(6; "Related Scope"; Option)
        {
            Caption = 'Related Scope';
            OptionMembers = System,Tenant;
            OptionCaption = 'System,Tenant';
        }
    }

    keys
    {
        key(Key1; "App ID", "Role ID", "Related App ID", "Related Role ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


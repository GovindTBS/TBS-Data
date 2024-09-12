// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Reflection;

table 2000000177 "Tenant Profile"
{
    Caption = 'Tenant Profile';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    ObsoleteState = Pending;
    ObsoleteReason = 'The table will only contain the profiles created using the in-client profile configuration and will not contain profiles from extensions anymore. Use the AllProfile table instead.';
    InherentPermissions = RX;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(2; "Profile ID"; Code[30])
        {
            Caption = 'Profile ID';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
            ObsoleteReason = 'Stored in the Metadata field of the Tenant Profile table.';
            ObsoleteState = Pending;
        }
        field(4; "Role Center ID"; Integer)
        {
            Caption = 'Role Center ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
            ObsoleteReason = 'Stored in the Metadata field of the Tenant Profile table.';
            ObsoleteState = Pending;
        }
        field(5; "Default Role Center"; Boolean)
        {
            Caption = 'Default Role Center';
            ObsoleteReason = 'Moved to the Tenant Profile Setting table.';
            ObsoleteState = Pending;
        }
        field(6; "Disable Personalization"; Boolean)
        {
            Caption = 'Disable Personalization';
            ObsoleteReason = 'Moved to the Tenant Profile Setting table.';
            ObsoleteState = Pending;
        }
        field(7; Metadata; BLOB)
        {
            Caption = 'Metadata';
        }
        field(8; "User AL Code"; BLOB)
        {
            Caption = 'User AL Code';
        }
        field(9; "Customization Status"; Option)
        {
            Access = Internal;
            Caption = 'Customization Status';
            OptionCaption = 'Updated,Recompilation Needed,Recompilation Failed';
            OptionMembers = Updated,"Recompilation Needed","Recompilation Failed";
        }
        field(10; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }
    }

    keys
    {
        key(Key1; "App ID", "Profile ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


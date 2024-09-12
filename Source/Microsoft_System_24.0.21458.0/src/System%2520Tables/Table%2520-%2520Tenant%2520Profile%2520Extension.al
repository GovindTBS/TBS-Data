// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000084 "Tenant Profile Extension"
{
    Caption = 'Tenant Profile Extension';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "App ID"; Guid)
        {
            Caption = 'App ID';
        }
        field(2; "Base Profile App ID"; Guid)
        {
            Caption = 'Base Profile App ID';
        }
        field(3; "Base Profile ID"; Code[30])
        {
            Caption = 'Base Profile ID';
        }
        field(4; Metadata; BLOB)
        {
            Caption = 'Metadata';
        }
        field(5; "User AL Code"; BLOB)
        {
            Caption = 'User AL Code';
        }
        field(6; "Emit Version"; Integer)
        {
            Caption = 'Emit Version';
        }
        field(7; "Customization Status"; Option)
        {
            Access = Internal;
            Caption = 'Customization Status';
            OptionCaption = 'Updated,Recompilation Needed,Recompilation Failed';
            OptionMembers = Updated,"Recompilation Needed","Recompilation Failed";
        }
    }

    keys
    {
        key(Key1; "App ID", "Base Profile App ID", "Base Profile ID")
        {
            Clustered = true;
        }

        key(Key2; "Base Profile App ID", "Base Profile ID")
        {
        }
    }

    fieldgroups
    {
    }
}


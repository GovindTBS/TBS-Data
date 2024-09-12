// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

using System.Security.AccessControl;

table 2000000067 "User Default Style Sheet"
{
    Caption = 'User Default Style Sheet';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;

    fields
    {
        field(1; "User ID"; Guid)
        {
            Caption = 'User ID';
            TableRelation = User."User Security ID";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(2; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = ,"Report","Page";
            OptionCaption = ',Report,Page';
        }
        field(3; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            TableRelation = System.Reflection.Object.ID WHERE(Type = FIELD("Object Type"));
        }
        field(4; "Program ID"; Guid)
        {
            Caption = 'Program ID';
        }
        field(5; "Style Sheet ID"; Guid)
        {
            Caption = 'Style Sheet ID';
        }
    }

    keys
    {
        key(Key1; "User ID", "Object Type", "Object ID", "Program ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


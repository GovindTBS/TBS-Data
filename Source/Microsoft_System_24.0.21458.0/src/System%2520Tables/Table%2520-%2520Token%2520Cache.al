// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.Authentication;

using System.Security.AccessControl;

table 2000000197 "Token Cache"
{
    Caption = 'Token Cache';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;
    CompressionType = None;

    fields
    {
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            TableRelation = User."User Security ID";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(2; "User Unique ID"; Guid)
        {
            Caption = 'User Unique ID';
        }
        field(3; "Tenant ID"; Guid)
        {
            Caption = 'Tenant ID';
        }
        field(4; "Cache Write Time"; DateTime)
        {
            Caption = 'Cache Write Time';
        }
        field(5; "Cache Data"; BLOB)
        {
            Caption = 'Cache Data';
        }
        field(6; "User String Unique ID"; Text[80])
        {
            Caption = 'User String Unique ID';
        }
        field(7; "Tenant String Unique ID"; Text[80])
        {
            Caption = 'Tenant String Unique ID';
        }
        field(8; "Home Account ID"; Text[120])
        {
            Caption = 'Home Account ID';
        }
        field(9; "Login Hint"; Text[120])
        {
            Caption = 'Login Hint';
        }
        field(10; "Session Cache Key"; Text[120])
        {
            Caption = 'Session Cache Key';
        }
    }

    keys
    {
        key(Key1; "User Security ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


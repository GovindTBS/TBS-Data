// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 2000000009 Session
{
    DataPerCompany = false;
    Scope = Cloud;
    //WriteProtected=True;
    fields
    {
        field(1; "Connection ID"; Integer)
        {
        }
        field(2; "User ID"; Text[64])
        {
        }
        field(3; "My Session"; Boolean)
        {
        }
        field(5; "Login Time"; Time)
        {
        }
        field(6; "Login Date"; Date)
        {
        }
        field(16; "Database Name"; Text[128])
        {
        }
        field(17; "Application Name"; Text[64])
        {
        }
        field(18; "Login Type"; Option)
        {
            OptionMembers = None,Windows,"Username and Password","Access Control Service";
        }
        field(19; "Host Name"; Text[64])
        {
        }
    }

    keys
    {
        key(pk; "Connection ID")
        {
        }
        key(fk1; "User ID")
        {
        }
        key(fk2; "Login Date", "Login Time")
        {
        }
        key(fk3; "Application Name")
        {
        }
        key(fk4; "Host Name")
        {
        }
    }
}
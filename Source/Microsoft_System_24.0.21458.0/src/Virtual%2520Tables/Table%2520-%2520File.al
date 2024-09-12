// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.IO;

table 2000000022 "File"
{
    Scope = OnPrem;
    fields
    {
        field(1; "Path"; Code[98])
        {
        }
        field(2; "Is a file"; Boolean)
        {
        }
        field(3; "Name"; Text[99])
        {
        }
        field(4; Size; Integer)
        {
        }
        field(5; "Date"; Date)
        {
        }
        field(6; "Time"; Time)
        {
        }
        field(7; "Data"; Blob)
        {
        }
    }

    keys
    {
        key(pk; "Path", "Is a file", "Name")
        {

        }
    }
}
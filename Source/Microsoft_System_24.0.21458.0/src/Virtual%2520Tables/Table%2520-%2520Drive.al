// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.IO;

table 2000000020 Drive
{
    Scope = OnPrem;

    fields
    {
        field(1; Drive; Code[2])
        {
        }
        field(2; Removable; Boolean)
        {
        }
        field(3; "Size (KB)"; Integer)
        {
        }
        field(4; "Free (KB)"; Integer)
        {
        }
    }

    keys
    {
        key(pk; Drive)
        {

        }
    }
}
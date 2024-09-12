// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

table 2000000040 "License Information"
{
    DataPerCompany = false;
    Scope = Cloud;

    fields
    {
        field(1; "Line No."; Integer)
        {
        }
        field(2; Text; Text[250])
        {
        }
    }

    keys
    {
        key(pk; "Line No.")
        {

        }
    }
}
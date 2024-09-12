// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Utilities;

table 2000000026 Integer
{
    DataPerCompany = False;
    Scope = Cloud;
    //WriteProtected=True;
    fields
    {
        field(1; Number; Integer)
        {
        }
    }

    Keys
    {
        key(pk; Number)
        {
        }
    }
}
// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Device;

table 2000000039 Printer
{
    DataPerCompany = False;
    Scope = Cloud;

    fields
    {
        field(1; ID; Text[250])
        {
        }
        field(2; Name; Text[250])
        {
        }
        field(3; Driver; Text[50])
        {
        }
        field(4; Device; Text[50])
        {
        }

        /// <summary>
        /// The information about the printer.
        /// </summary>
        field(5; Payload; Text[2048])
        {
        }

        /// <summary>
        /// The representation of the printer.
        /// </summary>
        field(6; Description; Text[250])
        {
        }
    }

    keys
    {
        key(pk; ID)
        {

        }
    }
}
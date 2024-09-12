// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000192 "Page Control Field"
{
    Caption = 'Page Control Field';
    DataPerCompany = false;
    Scope = Cloud;

    fields
    {
        field(1; PageNo; Integer)
        {
            Caption = 'PageNo';
        }
        field(2; ControlId; Integer)
        {
            Caption = 'ControlId';
        }
        field(3; ControlName; Text[120])
        {
            Caption = 'ControlName';
        }
        field(4; TableNo; Integer)
        {
            Caption = 'TableNo';
        }
        field(5; FieldNo; Integer)
        {
            Caption = 'FieldNo';
        }
        field(6; Enabled; Text[512])
        {
            Caption = 'Enabled';
        }
        field(7; Editable; Text[512])
        {
            Caption = 'Editable';
        }
        field(8; Visible; Text[512])
        {
            Caption = 'Visible';
        }
        field(9; SourceExpression; Text[512])
        {
            Caption = 'Source Expression';
        }
        field(10; OptionString; Text[2048])
        {
            Caption = 'Option String';
        }
        field(11; Sequence; Integer)
        {
            Caption = 'Sequence';
        }
    }
    keys
    {
        key(Key1; PageNo, ControlId)
        {
        }
    }
}
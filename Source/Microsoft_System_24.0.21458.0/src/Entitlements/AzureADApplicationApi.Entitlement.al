// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace System.Security.AccessControl;

entitlement "Azure AD Application Api"
{
    Type = ApplicationScope;
    Id = 'API.ReadWrite.All';

    ObjectEntitlements = "AzureADApplicationApi";
}

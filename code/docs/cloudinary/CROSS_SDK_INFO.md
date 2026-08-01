## Cross-SDK info

**Claude Model:** opus — Cross-SDK config params, transformation syntax, input validation

### Configuration parameters

The first step in setting up any Cloudinary SDK is to set the global configuration parameters in the relevant configuration file (see the relevant SDK guide above for details on where and how to configure them for your SDK).

- The `cloud_name` product environment identifier must be set for every SDK.
- Your product environment `api_key` and `api_secret` are mandatory configurations for all [backend SDKs](backend_sdks). (The `api_secret` should never be exposed in client-side code.)
- For all legacy SDKs, you'll probably want to set the `secure` parameter to `true` to ensure that your transformation URLs are always generated as HTTPS. (In [SDK **major versions** with initial release in 2020 or later](#post_2020_sdks), this configuration parameter is `true` by default.)
- There are also a number of additional optional configuration parameters you may want to define at a global level.

You can additionally set any of these configuration parameters in individual operations, which then overrides the globally set or default configuration values for that command.

The table below details all available Cloudinary SDK configuration parameters.

For details and examples of where and how to define these configuration parameters, see the relevant Cloudinary SDK framework guide.

> **TIP**:
>
> In some SDK languages, you may need to adjust the case of the parameters shown below (for example to **camelCase** or **kebab-case**) to match the conventions of the language you are using.

| Parameter                                                                    | Type    | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ---------------------------------------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Cloud**                                                                    |         |
| cloud_name                                                                   | string  | Mandatory. The cloud name of your product environment. Used to build the public URL for all your media assets.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| api_key                                                                      | string  | Mandatory for server-side operations. Used together with the API secret to communicate with the Cloudinary API and sign requests.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| api_secret                                                                   | string  | Mandatory for server-side operations. Used together with the API key to communicate with the Cloudinary API and sign requests.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| **URL**                                                                      |         |
| secure                                                                       | Boolean | Optional. Force HTTPS URLs for asset delivery even if they are embedded in non-secure HTTP pages. In most cases, it's recommended to keep (or set) this parameter as `true`. **Default**: `true` for [SDK **major versions** with initial release in 2020 or later](#post_2020_sdks).`false` for SDK **major versions** with initial release in 2019 or earlier.                                                                                                                                                                                                                                                                                                                                     |
| secure_distribution &#124; (cname)                                           | string  | Optional. The custom delivery hostname (CNAME) to use for building URLs. Relevant only for users on [Advanced plans](https://cloudinary.com/pricing) or higher that have a custom CNAME. For details, see [Private CDNs and custom delivery hostnames (CNAMEs)](advanced_url_delivery_options#private_cdns_and_custom_delivery_hostnames_cnames).**Note**: Use `secure_distribution` (`secureCname` in PHP SDK v2.x and `secure_cname` in the Go SDK) to specify your organization's CNAME whenever `secure` is true. (The legacy `cname` configuration parameter should be used only if `secure` is set to false.)                                                                                  |
| private_cdn                                                                  | Boolean | Optional. Set this parameter to `true` if you are an [Advanced plan](https://cloudinary.com/pricing) user with a private CDN distribution. **Default**: `false`. For details, see [Private CDNs and custom delivery hostnames (CNAMEs)](advanced_url_delivery_options#private_cdns_and_custom_delivery_hostnames_cnames).                                                                                                                                                                                                                                                                                                                                                                            |
| upload_prefix (ApiBaseAddress in .NET)                                       | string  | Optional. Replaces the `https://api.cloudinary.com` part of the API endpoint with the string specified. Relevant only for [Enterprise plan](https://cloudinary.com/pricing#pricing-enterprise) users that are using an [alternative data center](admin_api#alternative_data_centers_and_endpoints_premium_feature), for example `https://api-eu.cloudinary.com`.                                                                                                                                                                                                                                                                                                                                     |
| analytics (urlAnalytics in Node.js)                                          | Boolean | Optional. When `true`, URLs generated by the SDK include an appended query parameter that passes SDK usage information. This data is used in aggregate form to help Cloudinary improve future SDK versions. No individual data is collected and this data cannot be used to identify end users in any way.Note that if you have developed proprietary functionality that relies on asset delivery URL values (CDN-based functionality, other query parameters, local storage of asset delivery URLs, etc), the appended query param could impact that functionality.**Default**: `true`.Relevant only for [SDKs with major versions that were initially released in 2020 or later](#post_2020_sdks). |
| cdn_subdomain                                                                | Boolean | Optional. Whether to automatically build URLs with multiple CDN sub-domains when using HTTP delivery (for example `http://res-1.cloudinary.com` ... `http://res-5.cloudinary.com`, or `http://a1.<mydomain.com>` ... `http://a5.<mydomain.com>` for CNAMEs). **Note**: Supported for backward compatibility only. In most cases, this option is no longer relevant. **Default**: `false`.                                                                                                                                                                                                                                                                                                            |
| **Other**                                                                    |         |
| upload_preset                                                                | string  | Optional. The name of a defined [upload preset](upload_presets). You can create upload presets in the **Upload** page of the Cloudinary Console Settings or using the [upload_preset](admin_api#upload_presets) method of the Admin API. If you are planning to offer unsigned uploads, you can define an unsigned upload preset to use with all uploads. This is especially useful for frontend SDKs.                                                                                                                                                                                                                                                                                               |
| api_proxy 1                                                                  | string  | Optional. The URL of a proxy server in your environment for routing all Cloudinary [Admin API](admin_api) and [Upload API](image_upload_api_reference) method calls to Cloudinary.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| signature_algorithm                                                          | enum    | Optional. Sets the algorithm to use when the SDK generates a [signature](signatures) for API calls or URL generation. **Possible values**: `sha1` (default), `sha256`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| **Provisioning**                                                             |         |
| account*api_key \_previously referred to as provisioning_api_key*            | string  | Mandatory for [Provisioning API](provisioning_api) operations. Used together with the Provisioning API secret to communicate with the Cloudinary API and authenticate provisioning requests.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| provisioning*api_secret \_previously referred to as provisioning_api_secret* | string  | Mandatory for [Provisioning API](provisioning_api) operations. Used together with the Provisioning API key to communicate with the Cloudinary API and authenticate provisioning requests.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| account_id                                                                   | string  | Mandatory for [Provisioning API](provisioning_api) operations. The ID of the Cloudinary product environment for provisioning.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Rails SDK only**                                                           |         |
| static_image_support                                                         | Boolean | Relevant the Ruby/Rails SDK only. Optional. Whether to deliver uploaded static images through Cloudinary. **Default**: `false`. For details, see [Rails Static images](rails_image_manipulation#static_files).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| enhance_image_tag                                                            | Boolean | Relevant for the Ruby/Rails SDK only. Optional. Whether to wrap the standard `image_tag` view helper's method. **Default**: `false`. Set this parameter to `true` if `static_image_support` is set to `true`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **Python SDK only**                                                          |         |
| disable_tcp_keep_alive                                                       | Boolean | Relevant for Python SDK only. Optional. If `true` disables TCP socket keep-alive. **Default**: `false`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **Node SDK only**                                                            |         |
| hide_sensitive                                                               | Boolean | Relevant for Node SDK only. Optional. Whether to ensure tokens, API keys and API secrets aren’t shown in error responses. **Default**: `false`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |

> **NOTES**: :title=Footnote

1. If you're using the Python SDK and [setting your configuration parameters globally](django_integration#setting_configuration_parameters_globally), you must set your configuration parameters before importing the `cloudinary.uploader` and `cloudinary.api` classes in order to set up a proxy server successfully.

### SDKs with action-based syntax

Most of Cloudinary's newer SDK major versions use an action-based syntax for transformations. While the exact syntax for each SDK differs based on its programming language, the concept behind the syntax follows these principles:

- The syntax is action-based, designed to make building delivery URLs and transformations more logical.
- It allows discovering the available options from within your development environment, and ensures that only options that are supported can be used together.

The general form of the syntax is:

![Transformation general syntax](https://cloudinary-res.cloudinary.com/image/upload/f_auto/q_auto/v1611141878/docs/sdk/general_syntax-2.png "thumb: w_750,dpr_2, width:750")

An example being:

![Transformation structure](https://cloudinary-res.cloudinary.com/image/upload/f_auto/q_auto/v1622194610/docs/sdk/js2-syntax.png "thumb: w_650,dpr_2, width:650")

The syntax is based on Actions, ActionGroups, and Qualifiers:

- Assets expose methods called **Action Groups** (`myImage.adjust()`) that represent a directive to Cloudinary on how to transform a specific aspect of an asset
- Action Groups receive an **Action** object as a parameter that defines the specific action to apply
- Action objects are created through Factory methods (`Adjust.replaceColor()`)
- Some actions require a **Qualifier** as a parameter (`lightblue`)
- Qualifiers usually accept a **QualifierValue** (`17` in `tolerance(17)`).

### Post-2020 SDKs

Cloudinary SDKs with a major version released in 2020 or later have a few global differences from SDK major versions released before that. For example, in the newer major versions:

- The default value for the `secure` configuration parameter is `true`. (The default value remained false in older major versions for backward compatibility reasons).
- The `analytics` configuration parameter is supported.

The following SDK libraries were released after 2020:

- **Ruby/Rails**: [cloudinary 2.x and later](https://github.com/cloudinary/cloudinary_gem/blob/master/CHANGELOG.md)
- **Node.js**: [@cloudinary 2.x and later](https://github.com/cloudinary/cloudinary_npm/blob/master/CHANGELOG.md)
- **Java**: [@cloudinary 2.x and later](https://github.com/cloudinary/cloudinary_java/blob/master/CHANGELOG.md)
- **React**: [@cloudinary/react 1.x and later](https://github.com/cloudinary/frontend-frameworks/blob/master/CHANGELOG.md)
- **Vue.js**: [@cloudinary/vue 1.x and later](https://github.com/cloudinary/frontend-frameworks/blob/master/CHANGELOG.md)
- **Angular**: [@cloudinary/ng 1.x and later](https://github.com/cloudinary/frontend-frameworks/blob/master/packages/angular/CHANGELOG.md)
- **JavaScript**: [@cloudinary/url-gen 1.x and later](https://github.com/cloudinary/js-url-gen/blob/master/CHANGELOG.md)
- **PHP**: [cloudinary_php 2.x and later](https://github.com/cloudinary/cloudinary_php/blob/master/CHANGELOG.md)
- **iOS**: [cloudinary 3.x and later](https://github.com/cloudinary/cloudinary_ios/blob/master/CHANGELOG.md)
- **Android**: [cloudinary-android 2.x and later](https://github.com/cloudinary/cloudinary_android/blob/master/CHANGELOG.md)
- **Flutter**: [cloudinary_flutter 1.x and later](https://github.com/cloudinary/cloudinary_flutter/blob/master/CHANGELOG.md)
- **Kotlin**: [kotlin-url-gen 1.x and later](https://github.com/cloudinary/cloudinary_kotlin/blob/master/CHANGELOG.md)
- **React Native**: [cloudinary-react-native 0.x and later](https://github.com/cloudinary/cloudinary-react-native/blob/master/CHANGELOG.md)

### SDK browser support

The most recent five versions of the following browsers are regularly tested with Cloudinary's SDKs and are officially supported:

#### Desktop

- Google Chrome
- Microsoft Edge
- Mozilla Firefox
- Safari

#### Mobile

- Mobile Chrome
- Mobile Firefox
- Mobile Safari

> **NOTES**:
>
> - Internet Explorer 11 and earlier is not supported.

> - Other browsers not mentioned above may work well, but have not been tested. If there is another popular browser that you think we should add to our browser support matrix, please submit a [support request](https://support.cloudinary.com/hc/en-us/requests/new) and we will evaluate it.

### Validating user input

It's considered best practice to validate and sanitize any user-provided input before including it in Cloudinary API calls (e.g., `public_id`, `tags`, `context`, `custom_coordinates`). Input from external sources may be unsafe, and unvalidated data can result in malformed requests, security vulnerabilities, or unintended behavior.

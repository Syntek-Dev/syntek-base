> ## Documentation Index
>
> Fetch the complete documentation index at: https://cloudinary.com/documentation/llms.txt
> Use this file to discover all available pages before exploring further.

# Python SDK

**Claude Model:** opus — Cloudinary Python SDK upload, admin API, and exception handling

[sample-projects-link]: python_sample_projects
[changelog-link]: https://github.com/cloudinary/pycloudinary/blob/master/CHANGELOG.md

The Cloudinary Python SDK provides simple, yet comprehensive image and video upload, transformation, optimization, and delivery capabilities through the [Cloudinary APIs](cloudinary_references#url_and_rest_apis), that you can implement using code that integrates seamlessly with your existing Python application.

Most of the functionality provided by Cloudinary can be implemented using Python, regardless of your framework. However, some features are available only for Django.

Feature list

**Cross-framework features (Flask & Django)**

- Build URLs for [image](django_image_manipulation) and [video](django_video_manipulation) transformation
- API wrappers: [file upload](image_upload_api_reference), [administration](admin_api), [transformations](transformation_reference) and more
- [Server-side](django_image_and_video_upload#server_side_upload) file upload + [direct unsigned](django_image_and_video_upload#direct_uploading_from_the_browser) file upload from the browser using the jQuery plugin

**Django-specific features**

- [Form and model](django_image_and_video_upload#django_forms_and_models) integration classes
- [Template tags](django_image_manipulation#template_tags) for embedding and transforming resources

> **INFO**: :title=SDK security upgrade, June 2025

We recently released an enhanced security version of this SDK that improves the validation and handling of input parameters. We recommend upgrading to the [latest version][changelog-link] of the SDK to benefit from these security improvements.

## How would you like to learn?

| {table:class=no-borders overview}Resource                                                                                                                                                                                                                                        | Description                                                                                                                                            |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Python quick start](python_quickstart)                                                                                                                                                                                                                                          | Get up and running in five minutes with a walk through of installation, configuration, upload, management and transformations.                         |
| [Video tutorials](python_video_tutorials)                                                                                                                                                                                                                                        | Watch tutorials relevant to your use cases, from getting started with the Python SDK, to uploading, transforming and analyzing your images and videos. |
| [Sample projects](python_sample_projects)                                                                                                                                                                                                                                        | Explore sample projects to see how to implement Cloudinary functionality such as upload and delivery with transformations.                             |
| [Cloudinary Python SDK GitHub repo](https://github.com/cloudinary/pycloudinary)                                                                                                                                                                                                  | Explore the source code and see the [CHANGELOG][changelog-link] for details on all new features and fixes from previous versions.                      |
| Try the free [Introduction to Cloudinary for Python Developers](https://training.cloudinary.com/courses/introduction-to-cloudinary-for-python-developers-90-minute-course) online course, where you can learn how to upload, manage, transform and optimize your digital assets. |

Other helpful resources...

This guide focuses on how to set up and implement popular Cloudinary capabilities using the Python SDK, but it doesn't cover every feature or option. Check out these other resources to learn about additional concepts and functionality in general.

| {table:class=no-borders overview}Resource | Description                                                                                   |
| ----------------------------------------- | --------------------------------------------------------------------------------------------- |
| [Developer kickstart](dev_kickstart)      | A hands-on, step-by-step introduction to Cloudinary features.                                 |
| [Glossary](cloudinary_glossary)           | A helpful resource to understand Cloudinary-specific terminology.                             |
| [Guides](programmable_media_guides)       | In depth guides to help you understand the many, varied capabilities provided by the product. |
| [References](cloudinary_references)       | Comprehensive references for all APIs, including Python code examples.                        |

## Install

1. Install Cloudinary's module using either **easy_install** or **pip** package management tools:

   ```
   pip install cloudinary
   ```

   > **NOTE**: Check that you're using a [supported version](https://github.com/cloudinary/cloudinary_npm#version-support) of Python.

2. Add `cloudinary` to the list of **INSTALLED_APPS** in **settings.py**.

## Configure

Include Cloudinary's Python classes in your code:

```
import cloudinary
import cloudinary.uploader
import cloudinary.api

# Import the CloudinaryImage and CloudinaryVideo methods for the simplified syntax used in this guide
from cloudinary import CloudinaryImage
from cloudinary import CloudinaryVideo
```

> **NOTE**: You can also initialize Cloudinary tags in your Django templates by entering:

    ```
    {% load cloudinary %}
    ```

### Set required configuration parameters

You can set the required configuration parameters, `cloud_name`, `api_key` and `api_secret` either using the `CLOUDINARY_URL` environment variable, or using the `config` method in your code.

To define the `CLOUDINARY_URL` environment variable:

1. Copy the **API environment variable** format from the [API Keys](https://console.cloudinary.com/app/settings/api-keys) page of the Cloudinary Console Settings.
2. Replace `<your_api_key>` and `<your_api_secret>` with your actual values. Your cloud name is already correctly included in the format.

For example:

```
CLOUDINARY_URL=cloudinary://my_key:my_secret@my_cloud_name
```

> **NOTE**: When using Cloudinary through a PaaS add-on, such as Heroku, this environment variable is automatically defined in your deployment environment.

Alternatively, you can use the `config` method to set your `cloud_name`, `api_key` and `api_secret`, for example:

```python
import cloudinary

cloudinary.config(
  cloud_name = "my_cloud_name",
  api_key = "my_key",
  api_secret = "my_secret"
)
```

> **INFO**:
>
> - When writing your own applications, follow your organization's policy on storing secrets and don't expose your API secret. \* If you use a method that involves writing your environment variable to a file (e.g., using `.env` with `python-dotenv`), the file should be excluded from your version control system so as not to expose it publicly.
>   **TIP**: To generate transformation URLs, you only need to configure the cloud name. The API key and API secret aren't required for URL generation.

### Set additional configuration parameters

In addition to the required configuration parameters, you can define a number of optional [configuration parameters](cloudinary_sdks#configuration_parameters) if relevant.

You can append configuration parameters, for example `upload_prefix` and `secure_distribution`, to the environment variable:

```
CLOUDINARY_URL=cloudinary://my_key:my_secret@my_cloud_name?secure_distribution=mydomain.com&upload_prefix=https://api-eu.cloudinary.com
```

Or you can use the `config` method in your code, for example:

```python
cloudinary.config(
  cloud_name = "my_cloud_name",
  api_key = "my_key",
  api_secret = "my_secret",
  secure_distribution = "mydomain.com",
  upload_prefix = "myprefix"
)
```

> **NOTE**: By default, URLs generated with this SDK include an appended SDK-usage query parameter. Cloudinary tracks aggregated data from this parameter to improve future SDK versions and no individual data is collected. If needed, you can disable the `urlAnalytics` configuration option. [Learn more](cloudinary_sdks#analytics_config).

> **TIP**: If you want to pass the optional [api_proxy](cloudinary_sdks#configuration_parameters) configuration parameter, you must call `cloudinary.config()` before importing the `cloudinary.uploader` and `cloudinary.api` classes:

```python
import cloudinary

cloudinary.config(
cloud_name = "xxxx",
api_key = "xxxxxxxxxxxx",
api_secret = "xxxxxxxxxxx",
api_proxy = "http://proxy.server:9999"
)

import cloudinary.uploader
import cloudinary.api
```

### Configuration video tutorials

The following tutorials can help you install and set up your SDK.

    Find Your Credentials
    Find your Cloudinary credentials for APIs and SDKs





    Configure the Python SDK
    Install and configure the Cloudinary Python SDK

See more [Python video tutorials](python_video_tutorials).

## Use

Once you've installed and configured the Python SDK, you can use it for:

- **Uploading files to your product environment**: You can upload any files, not only images and videos, set your own naming conventions and overwrite policies, moderate and tag your assets on upload, and much more. [See&nbsp;example](#quick_example_file_upload)
- **Transforming and optimizing images and videos**: Keeping your original assets intact in your product environment, you can deliver different versions of your media - different sizes, formats, with effects and overlays, customized for your needs. [See&nbsp;example](#quick_example_transform_and_optimize)
- **Managing assets**: Using methods from the Admin and Upload APIs, you can organize your assets, for example, list, rename and delete them, add tags and metadata and use advanced search capabilities. [See&nbsp;example](#quick_example_get_details_of_a_single_asset)

Capitalization and data type guidelines...

When using the Python SDK, keep these guidelines in mind:

- Parameter names: `snake_case`. For example: **public_id**
- Classes: `PascalCase`. For example: **CloudinaryField**
- Methods: `snake_case`. For example: **add_tag**
- Pass parameter data as: `dict or named arguments`

### Quick example: File upload

The following Python code uploads the `dog.mp4` video to the asset folder `pets` using the public_id, `my_dog`. The video will overwrite the existing video if a video with that public_id already exists. When the video upload is complete, the specified notification URL will receive details about the uploaded media asset.

```python
cloudinary.uploader.upload("dog.mp4",
  asset_folder = "pets",
  public_id = "my_dog",
  overwrite = True,
  notification_url = "https://mysite.example.com/notify_endpoint",
  resource_type = "video")
```

> **Learn more about upload**:
>
> - Read the [Upload guide](upload_images) to learn more about customizing uploads, using upload presets and more.

> - See more examples of [image and video upload](django_image_and_video_upload) using the Cloudinary Python library.

> - Explore the [Upload API reference](image_upload_api_reference) to see all available methods and options.

### Quick example: Transform and optimize

Take a look at the following transformation code and the image it delivers:

![sample transformation](https://res.cloudinary.com/demo/image/upload/c_thumb,g_face,h_150,w_150/r_20/e_sepia/l_cloudinary_icon/e_brightness:90/o_60/c_scale,w_50/fl_layer_apply,g_south_east,x_5,y_5/a_10/front_face.png "secure: true, disable_all_tab: true, with_url: false, frameworks:python")

```python
CloudinaryImage("front_face.png").image(transformation=[
  {'gravity': "face", 'height': 150, 'width': 150, 'crop': "thumb"},
  {'radius': 20},
  {'effect': "sepia"},
  {'overlay': "cloudinary_icon"},
  {'effect': "brightness:90"},
  {'opacity': 60},
  {'width': 50, 'crop': "scale"},
  {'flags': "layer_apply", 'gravity': "south_east", 'x': 5, 'y': 5},
  {'angle': 10}
  ])
```

This relatively simple code performs all of the following on the original front_face.jpg image before delivering it:

- **Crop** to a 150x150 thumbnail using face-detection gravity to automatically determine the location for the crop
- **Round the corners** with a 20 pixel radius
- Apply a **sepia effect**
- **Overlay the Cloudinary logo** on the southeast corner of the image (with a slight offset). The logo is scaled down to a 50 pixel width, with increased brightness and partial transparency (opacity = 60%)
- **Rotate** the resulting image (including the overlay) by 10 degrees
- **Convert** and deliver the image in PNG format (the originally uploaded image was a JPG)

And here's the URL that would be included in the image tag that's automatically generated from the above code:

![sample transformation](https://res.cloudinary.com/demo/image/upload/c_thumb,g_face,h_150,w_150/r_20/e_sepia/l_cloudinary_icon/e_brightness:90/o_60/c_scale,w_50/fl_layer_apply,g_south_east,x_5,y_5/a_10/front_face.png "secure: true, disable_all_tab: true, with_code:false, with_image:false")

In a similar way, you can [transform a video](django_video_manipulation#video_transformation_examples).

> **Learn more about transformations**:
>
> - Read the [image](image_transformations) and [video](video_manipulation_and_delivery) transformation guides to learn about the different ways to transform your assets.

> - See more examples of [image](django_image_manipulation) and [video](django_video_manipulation) transformations using the Cloudinary Python library.

> - See all possible transformations in the [Transformation URL API reference](transformation_reference).

### Quick example: Get details of a single asset

The following Python example uses the Admin API [resource](admin_api#get_details_of_a_single_resource_by_public_id) method to return details of the image with public ID `cld-sample`:

```python
result = cloudinary.api.resource('cld-sample')
print(result)
```

#### Sample response

```json
{
  "asset_id": "bf98540caf22ed65775ee0951f4746c9",
  "public_id": "cld-sample",
  "format": "jpg",
  "version": 1719304891,
  "resource_type": "image",
  "type": "upload",
  "created_at": "2024-06-25T08:41:31Z",
  "bytes": 476846,
  "width": 1870,
  "height": 1250,
  "backup": true,
  "asset_folder": "",
  "display_name": "cld-sample",
  "url": "http://res.cloudinary.com/cld-docs/image/upload/v1719304891/cld-sample.jpg",
  "secure_url": "https://res.cloudinary.com/cld-docs/image/upload/v1719304891/cld-sample.jpg",
  "next_cursor": "497b323dcb9883a15a5e6a7cfb75d439e4de1ca882f5cbe8de6a8b322c37bdad",
  "derived": [
    {
      "transformation": "c_scale,w_500",
      "format": "jpg",
      "bytes": 22871,
      "id": "ce3d7bf3068809656dc5aa76572535da",
      "url": "http://res.cloudinary.com/cld-docs/image/upload/c_scale,w_500/v1719304891/cld-sample.jpg",
      "secure_url": "https://res.cloudinary.com/cld-docs/image/upload/c_scale,w_500/v1719304891/cld-sample.jpg"
    }
  ]
}
```

> **Learn more about managing assets**:
>
> - Check out the [Image and Video asset management](asset_management) guide for all the different capabilities.

> - Get an overview of [asset management](django_asset_administration) using the Python SDK.

> - Select the `Python` tab in the [Admin API](admin_api) and [Upload API](image_upload_api_reference) references to see example code snippets.

## Sample projects

Take a look at the [Python sample projects][sample-projects-link] page to help you get started integrating Cloudinary into your Python application.> **TIP**: Check out our collection of [Python sample apps](code_explorers) too!

> **READING**:
>
> - Try out the Python SDK using the [quick start](python_quickstart).

> - Learn more about [uploading images and videos](django_image_and_video_upload) using the Python SDK.

> - See examples of powerful [image](django_image_manipulation) and [video](django_video_manipulation) transformations using Python code and see our [image transformations](image_transformations) and [video transformation](video_manipulation_and_delivery) docs.

> - Check out Cloudinary's [asset management](django_asset_administration) capabilities, for example, renaming and deleting assets, adding tags and metadata to assets, and searching for assets.

> - Stay tuned for updates by following the [Release Notes](programmable_media_release_notes) and the [Cloudinary Blog](https://cloudinary.com/blog).

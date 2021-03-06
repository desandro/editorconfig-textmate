EditorConfig—TextMate PlugIn
============================

This is a TextMate plug-in that provides support for [Editor Config](http://editorconfig.org/). It will cause TextMate to set its editing features (e.g. tab style and size) according to a `.editorconfig` file you include alongside your source code.

Download it now at: https://github.com/downloads/Mr0grog/editorconfig-textmate/editorconfig-textmate-0.2.tar.gz

Works in both TextMate and TextMate 2 Alpha (as of build 9147).


Feature Support
---------------

The following Editor Config features are supported:

- root
- indent_style ("tab" or "space")
- indent_size
- tab_width

The `end_of_line` feature is not yet supported. Neither are upcoming features like `charset`, `trim_trailing_whitespace`, and `insert_final_newline`.


Installation
------------

You can download a precompiled binary from GitHub's downloads page:

https://github.com/Mr0grog/editorconfig-textmate/downloads

Just un-tar it and double-click the `editorconfig-textmate.tmplugin` file to install.


To-Do
-----

Currently, [editorconfig-core](https://github.com/editorconfig/editorconfig-core) is included as a precompiled binary, but it really should be included as a submodule, with an appropriate build target in Xcode.

Support for `end_of_line` is also needed, but I have to figure out exactly how to do it in TextMate first :P


TextMate 2
----------

While this plug-in does support the TextMate 2 Alpha, please keep in mind that alpha software is subject to great change. It could break in future releases of TextMate. If this happens, please file an issue: https://github.com/Mr0grog/editorconfig-textmate/issues

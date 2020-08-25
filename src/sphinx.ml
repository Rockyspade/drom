(**************************************************************************)
(*                                                                        *)
(*    Copyright 2020 OCamlPro & Origin Labs                               *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

open Types

let subst p s =
  let b = Buffer.create ( 2 * String.length s ) in
  Buffer.add_substitute b
    (function
      | "name" -> p.name
      | "synopsis" -> p.synopsis
      | "description" -> p.description
      | "version" -> p.version
      | "edition" -> p.edition
      | "min-edition" -> p.min_edition
      | "authors-list" -> String.concat "\n* " p.authors
      | "copyright" -> begin
          match p.copyright with
          | None -> "(see authors)"
          | Some copyright -> copyright
        end
      | "license" -> License.license p
      | v -> Printf.sprintf "${%s}" v
    ) s ;
  Buffer.contents b

let conf_py p =
  let copyright =
    match p.copyright with
    | None -> "unspecified"
    | Some copyright -> copyright
  in
  Printf.sprintf
    {|
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# %s documentation build configuration file, created by
# sphinx-quickstart.
#
# This file is execfile()d with the current directory set to its
# containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# sys.path.insert(0, os.path.abspath('.'))

import os
import sys
import datetime
import subprocess
from os import environ
sys.path.insert(0, os.path.abspath('.') + '/_extensions')

# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
#extensions = ['sphinx.ext.extlinks']

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
#
source_suffix = ['.rst', '.md']
# source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = '%s'
copyright = '%s'
author = '%s'

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.

git = subprocess.check_output("git describe --always", shell=True).decode("utf-8")
branch= subprocess.check_output("git rev-parse --abbrev-ref HEAD", shell=True).decode("utf-8")
version = branch + " (" + git + ")"
# version = os.environ.get('CI_COMMIT_REF_NAME', 'v1.0')
# The full version, including alpha/beta/rc tags.
release = version + datetime.datetime.now().strftime(" (%%Y/%%m/%%d %%H:%%M)")
# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = None

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This patterns also effect to html_static_path and html_extra_path
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store', 'doc_gen']

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'lovelace'

# Deactivate syntax highlighting
# - http://www.sphinx-doc.org/en/stable/markup/code.html#code-examples
# - http://www.sphinx-doc.org/en/stable/config.html#confval-highlight_language
highlight_language = 'ocaml'
# TODO write a Pygments lexer for Michelson
# cf. http://pygments.org/docs/lexerdevelopment/ and http://pygments.org/docs/lexers/


# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_include_todos = False


# -- Options for HTML output ----------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = "sphinx_rtd_theme"

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#
html_theme_options = {'logo_only': True}
# html_logo = "logo.svg"
# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# Custom sidebar templates, must be a dictionary that maps document names
# to template names.
#
# This is required for the alabaster theme
# refs: http://alabaster.readthedocs.io/en/latest/installation.html#sidebars
# html_sidebars = {
#     '**': [
#         'relations.html',  # needs 'show_related': True theme option to display
#         'searchbox.html',
#     ]
# }


# -- Options for HTMLHelp output ------------------------------------------

# Output file base name for HTML help builder.
htmlhelp_basename = 'Liqdoc'


# -- Options for LaTeX output ---------------------------------------------

latex_elements = {
    'inputenc':'',
    'utf8extra': '',
    'preamble': r'''
      \usepackage{fontspec}
      \IfFontExistsTF{Lato}{\setsansfont{Lato}}{\setsansfont{Arial}}
      \IfFontExistsTF{Linux Libertine O}{
        \setromanfont[Scale=1.1]{Linux Libertine O}
      }{\setromanfont{Times New Roman}}
      \IfFontExistsTF{DejaVu Sans Mono}{
        \setmonofont[Scale=MatchLowercase]{DejaVu Sans Mono}
      }{\setmonofont[Scale=MatchLowercase]{Courier}}
    ''',

    # The paper size ('letterpaper' or 'a4paper').
    #
    # 'papersize': 'letterpaper',

    # The font size ('10pt', '11pt' or '12pt').
    #
    # 'pointsize': '10pt',

    # Additional stuff for the LaTeX preamble.
    #
    # 'preamble': '',

    # Latex figure (float) alignment
    #
    # 'figure_align': 'htbp',
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (master_doc, '%s.tex', '%s Documentation',
     'author', 'manual'),
]


# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, '%s', '%s Documentation',
     [author], 1)
]


# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (master_doc, '%s', '%s Documentation',
     author, '%s', 'One line description of project.',
     'Miscellaneous'),
]

# -- Ignore fragments in linkcheck

linkcheck_anchors = False


# -- Options for Epub output -------------------------------------------------

# Bibliographic Dublin Core info.
epub_title = project
epub_author = author
epub_publisher = author
epub_copyright = copyright

# The unique identifier of the text. This can be a ISBN number
# or the project homepage.
#
# epub_identifier = ''

# A unique identification for the text.
#
# epub_uid = ''

# A list of files that should not be packed into the epub file.
epub_exclude_files = ['search.html']

# entry point for setup
def setup(app):
    app.add_stylesheet('css/fixes.css')

|}
    p.name
    p.name
    copyright
    (String.concat " & " p.authors)
    p.name
    p.name
    p.name
    p.name
    p.name
    p.name
    p.name


let index_rst p =
  Printf.sprintf
  {|
.. %s documentation master file, created by
   drom new
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to %s doc
=================

.. toctree::
   :maxdepth: 2
   :caption: Documentation

%s   about
   install
%s   license
%s

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
|}
  p.name
  p.name
  ( match Misc.homepage p with
    | None -> ""
    | Some link -> Printf.sprintf "   Home <%s>\n" link )
  (match p.kind with
   | Program -> ""
   | Library | Both ->
     match Misc.doc_api p with
     | None -> ""
     | Some link -> Printf.sprintf "   API doc <%s>\n" link )
  (match p.github_organization with
   | None -> ""
   | Some github_organization ->
     Printf.sprintf {|
   Devel and Issues on Github <https://github.com/%s/%s>
|} github_organization p.name
  )


let install_rst p =
  subst p {|
How to install
==============

Install with :code:`opam`
-------------------------

If :code:`${name}` is available in your opam repository, you can just call::

  opam install ${name}

Build and install with :code:`dune`
-----------------------------------

Checkout the sources of :code:`${name}` in a directory.

You need a switch with at least version :code:`${min-edition}` of OCaml,
you can for example create it with::

  opam switch create ${edition}

Then, you need to install all the dependencies::

  opam install --deps-only .

Finally, you can build the package and install it::

  eval $(opam env)
  dune build
  dune install

Note that a :code:`Makefile` is provided, it contains the following
targets:

* :code:`build`: build the code
* :code:`install`: install the generated files
* :code:`build-deps`: install opam dependencies
* :code:`sphinx`: build sphinx documentation (from the :code:`sphinx/` directory)
* :code:`dev-deps`: build development dependencies, in particular
  :code:`ocamlformat`, :code:`odoc` and :code:`merlin`
* :code:`doc`: build documentation with :code:`odoc`
* :code:`fmt`: format the code using :code:`ocamlformat`
* :code:`test`: run tests

|}

let about_rst p =
  subst p {|
About
=====

${description}

Authors
-------

* ${authors-list}
|}

let license_rst p =
  subst p {|
Copyright and License
=====================

${license}

|}

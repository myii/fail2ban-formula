.. _readme:

fail2ban-formula
================

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/fail2ban-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/fail2ban-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

``fail2ban`` scans log files for malicious activity and executes actions based on what it finds.


.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see :ref:`How to contribute <CONTRIBUTING>` for more details.

Available states
----------------

.. contents::
   :local:


``fail2ban``
^^^^^^^^^^^^

Install the ``fail2ban`` package and enable the service.

``fail2ban.config``
^^^^^^^^^^^^^^^^^^^

Creates a ``jail.local`` config file based on pillar data to override configuration in the default ``jail.conf`` file and enables creation of all configuration files based on content blocks in pillar. See ``pillar.example`` for reference
and consult the fail2ban documentation.


The following states provide an alternate approach to managing fail2ban. Tested in Ubuntu 14/16 and CentOS 6/7.

.. contents::
    :local:

``fail2ban.ng``
^^^^^^^^^^^^^^^

Meta state for inclusion of all ng states.

``fail2ban.ng.install``
^^^^^^^^^^^^^^^^^^^^^^^

Install the ``fail2ban`` package.

``fail2ban.ng.config``
^^^^^^^^^^^^^^^^^^^^^^

Configure fail2ban creating a ``jail.local`` file based on pillar data that overrid ``jail.conf``. It also creates a ``file.local`` per action/filter. Either in jails, actions or filters is possible to setup a ``source_path`` options to upload your configuration directly (see ``pillar.example``). It is also possible to remove either actions or filters setting up ``enabled: False`` in it section (see ``pillar.example``).

Keep in mind that in ng states ``lookup``, ``config``, ``jails``, ``actions`` and ``filters`` are at the same level (in the old states, all the sections are under ``lookup``:

.. code-block:: yaml

  fail2ban:
    ng:
      lookup:
      config:
      jails:
      actions:
      filters:

Keep in mind also that in ng states change the syntax for the actions and filters adding a new `config` section and `enabled` option (optional):

.. code-block:: yaml

  fail2ban:
    ng:
      actions:
        name-of-action:
          enabled: True/False # OPTIONAL
          config:
            Definition:
                actionban:
                actionunban:
            Init:
                whatever:
      filters:
        name-of-filter:
          enabled: True/False # OPTIONAL
          config:
            Definition:
                failregex:

It is also possible to specify the source file for config, jails, actions and filters instead of using the template:

.. code-block:: yaml

  fail2ban:
    ng:
      config:
        source_path: salt://path-to-fail2ban-config-file
      jails:
        source_path: salt://path-to-fail2ban-config-file
      actions:
        name-of-action:
          config:
            source_path: salt://path-to-action-file
      filters:
        name-of-filter:
          config:
            source_path: salt://path-to-filter-file

``fail2ban.ng.service``
^^^^^^^^^^^^^^^^^^^^^^^

Manage fail2ban service. It is also possible to disable the service using the following pillar configuration:

.. code-block:: yaml

  fail2ban:
    ng:
      enabled: False


Testing
-------

Linux testing is done with ``kitchen-salt``.

``kitchen converge``
^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``template`` main state, ready for testing.

``kitchen verify``
^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``kitchen destroy``
^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``kitchen test``
^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``kitchen login``
^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.


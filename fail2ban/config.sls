{% from "fail2ban/map.jinja" import fail2ban with context %}

include:
  - fail2ban.deprecated
  - fail2ban

{{ fail2ban.prefix }}/etc/fail2ban/fail2ban.local:
{% if fail2ban.config %}
  file.managed:
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - context:
        config:
            Definition: {{ fail2ban.config|yaml }}
  cmd.run:
    - name: |
        cat {{ fail2ban.prefix }}/etc/fail2ban/fail2ban.local
    - require:
      - file: {{ fail2ban.prefix }}/etc/fail2ban/fail2ban.local
{% else %}
  file.absent:
{% endif %}
    - watch_in:
      - service: {{ fail2ban.service }}

{{ fail2ban.prefix }}/etc/fail2ban/jail.local:
{% if fail2ban.jails %}
  file.managed:
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - context:
        config: {{ fail2ban.jails|yaml }}
  cmd.run:
    - name: |
        cat {{ fail2ban.prefix }}/etc/fail2ban/jail.local
    - require:
      - file: {{ fail2ban.prefix }}/etc/fail2ban/jail.local
{% else %}
  file.absent:
{% endif %}
    - watch_in:
      - service: {{ fail2ban.service }}

{% for name, config in fail2ban.actions|dictsort %}
{{ fail2ban.prefix }}/etc/fail2ban/action.d/{{ name }}.local:
  file.managed:
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - watch_in:
      - service: {{ fail2ban.service }}
    - context:
        config: {{ config|yaml }}
  cmd.run:
    - name: |
        cat {{ fail2ban.prefix }}/etc/fail2ban/action.d/{{ name }}.local
    - require:
      - file: {{ fail2ban.prefix }}/etc/fail2ban/action.d/{{ name }}.local
{% endfor %}

{% for name, config in fail2ban.filters|dictsort %}
{{ fail2ban.prefix }}/etc/fail2ban/filter.d/{{ name }}.local:
  file.managed:
    - source: salt://fail2ban/files/fail2ban_conf.template
    - template: jinja
    - watch_in:
      - service: {{ fail2ban.service }}
    - context:
        config: {{ config|yaml }}
  cmd.run:
    - name: |
        cat {{ fail2ban.prefix }}/etc/fail2ban/filter.d/{{ name }}.local
    - require:
      - file: {{ fail2ban.prefix }}/etc/fail2ban/filter.d/{{ name }}.local
{% endfor %}


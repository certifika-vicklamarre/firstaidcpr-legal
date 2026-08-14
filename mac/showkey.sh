#!/bin/bash
# Prints the FirstAidCpr deploy key folded in 30-char lines so the agent can
# read it reliably from RDP screenshots (typing "_" is impossible over
# web-RDP, hence this fetched helper).
set -e
fold -w 30 ~/.ssh/id_firstaidcpr.pub

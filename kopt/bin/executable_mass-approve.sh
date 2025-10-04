#!/usr/bin/env bash
set -euo pipefail

show_help() {
    cat <<EOF
Usage: mass-approve.sh -f <title_filter> -m <approve_message>

Mass approves a list of PRs whose title match the provided title filter.
The PRs are all approved with the same message.

REQUIRED:
  -f <title_filter> only find PRs with this string in their title
  -m <approve_message> message to approve PRs with.

EXAMPLES:
  mass-approve.sh -f "Migrate DNS Resources" -m "I'm going to allow this"
EOF
    exit 0
}

TITLE_FILTER=""
MESSAGE=""

while getopts "f:m:h" opt; do
    case $opt in
    f)
        TITLE_FILTER="$OPTARG"
        ;;
    m)
        MESSAGE="$OPTARG"
        ;;
    h)
        show_help
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

if [ -z "${TITLE_FILTER}" ]; then
    echo "Error: no filter specified"
    echo ""
    show_help
fi

if [ -z "${MESSAGE}" ]; then
    echo "Error: no approval message specified"
    echo ""
    show_help
fi

PRS=$(gh pr list -S "${TITLE_FILTER} in:title" --json title,number --template '{{range .}}{{.number}},{{.title}}{{"\n"}}{{end}}')

if [ -z "${PRS}" ]; then
    echo "No PRS found"
    exit 0
fi

echo "Found PRs:"
while IFS="," read -r PR_NUMBER PR_TITLE; do
    echo "${PR_NUMBER} ${PR_TITLE}"
done <<<"$PRS"
echo ""

read -p "Approve PRS (y/n)? " -n 1 -r ANSWER
echo # (optional) move to a new line
if [[ ! $ANSWER =~ ^[Yy]$ ]]; then
    echo "not approving"
    exit 0
fi

while IFS="," read -r PR_NUMBER PR_TITLE; do
    echo "Approving ${PR_TITLE}"
    gh pr review -a -b "${MESSAGE}" "${PR_NUMBER}"
done <<<"$PRS"

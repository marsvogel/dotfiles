fpath=($HOME/.zsh/functions/** $fpath)

# PROMPT

# Options:
#
# The max execution time of a process before its run time is shown when
# it exits.
# PURE_CMD_MAX_EXEC_TIME=5
#
# Set PURE_GIT_PULL=0 to prevent Pure from checking whether the current
# Git remote has been updated.
# PURE_GIT_PULL=1
#
# Set PURE_GIT_UNTRACKED_DIRTY=0 to not include untracked files in
# dirtiness check. Only really useful on extremely huge repos like the
# WebKit repo.
# PURE_GIT_UNTRACKED_DIRTY=1
#
# Time in seconds to delay git dirty checking for large repositories
# (git status takes > 5 seconds). The check is performed asynchronously,
# this is to save CPU.
# PURE_GIT_DELAY_DIRTY_CHECK=1800
#
# Defines the prompt symbol.
# PURE_PROMPT_SYMBOL=❯
#
# Defines the git down arrow symbol.
# PURE_GIT_DOWN_ARROW=⇣
#
# Defines the git up arrow symbol.
# PURE_GIT_UP_ARROW=⇡

autoload -Uz promptinit && promptinit
prompt pure

# HISTORY

# Save each command’s beginning timestamp (in seconds since the epoch)
# and the duration (in seconds) to the history file. The format of this
# prefixed data is:
# ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt extendedhistory

# If the internal history needs to be trimmed to add the current command
# line, setting this option will cause the oldest history event that has
# a duplicate to be lost before losing a unique event from the list. You
# should be sure to set the value of HISTSIZE to a larger number than
# SAVEHIST in order to give you some room for the duplicated events,
# otherwise this option will behave just like HIST_IGNORE_ALL_DUPS once
# the history fills up with unique events.
setopt histexpiredupsfirst

# Do not enter command lines into the history list if they are
# duplicates of the previous event.
setopt histignoredups

# Remove command lines from the history list when the first character on
# the line is a space, or when one of the expanded aliases contains a
# leading space. Only normal aliases (not global or suffix aliases) have
# this behaviour. Note that the command lingers in the internal history
# until the next command is entered before it vanishes, allowing you to
# briefly reuse or edit the line. If you want to make it vanish right
# away without entering another command, type a space and press return.
setopt histignorespace

# Whenever the user enters a line with history expansion, don’t execute
# the line directly; instead, perform history expansion and reload the
# line into the editing buffer.
setopt histverify

# This options works like APPEND_HISTORY except that new history lines
# are added to the $HISTFILE incrementally (as soon as they are
# entered), rather than waiting until the shell exits. The file will
# still be periodically re-written to trim it when the number of lines
# grows 20% beyond the value specified by $SAVEHIST (see also the
# HIST_SAVE_BY_COPY option).
setopt incappendhistory

# When the history file is re-written, we normally write out a copy of
# the file named $HISTFILE.new and then rename it over the old one.
# However, if this option is unset, we instead truncate the old history
# file and write out the new version in-place. If one of the
# history-appending options is enabled, this option only has an effect
# when the enlarged history file needs to be re-written to trim it down
# to size. Disable this only if you have special needs, as doing so
# makes it possible to lose history entries if zsh gets interrupted
# during the save.
# When writing out a copy of the history file, zsh preserves the old
# file’s permissions and group information, but will refuse to write
# out a new file if it would change the history file’s owner.
setopt histsavebycopy

# This option both imports new commands from the history file, and also
# causes your typed commands to be appended to the history file (the
# latter is like specifying INC_APPEND_HISTORY, which should be turned
# off if this option is in effect). The history lines are also output
# with timestamps ala EXTENDED_HISTORY (which makes it easier to find
# the spot where we left off reading the file after it gets re-written).
# By default, history movement commands visit the imported lines as well
# as the local lines, but you can toggle this on and off with the
# set-local-history zle binding. It is also possible to create a zle
# widget that will make some commands ignore imported commands, and some
# include them.
# If you find that you want more control over when commands get
# imported, you may wish to turn SHARE_HISTORY off, INC_APPEND_HISTORY
# or INC_APPEND_HISTORY_TIME (see above) on, and then manually import
# commands whenever you need them using ‘fc -RI’.
setopt sharehistory

# The file to save the history in when an interactive shell exits. If
# unset, the history is not saved.
HISTFILE=~/.zshhistfile

# The maximum number of events stored in the internal history list. If
# you use the HIST_EXPIRE_DUPS_FIRST option, setting this value larger
# than the SAVEHIST size will give you the difference as a cushion for
# saving duplicated history events.
# If this is made local, it is not implicitly set to 0, but may be
# explicitly set locally.
HISTSIZE=8192

# The maximum number of history events to save in the history file.
# If this is made local, it is not implicitly set to 0, but may be
# explicitly set locally.
SAVEHIST=4096

# History search - by doing this, only the past commands matching the
# current line up to the current cursor position will be shown when Up
# or Down keys are pressed. 
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# COMPLETION

# To initialize the system, the function compinit should be in a
# directory mentioned in the fpath parameter, and should be autoloaded
# (‘autoload -U compinit’ is recommended), and then run simply as
# ‘compinit’. This will define a few utility functions, arrange for all
# the necessary shell functions to be autoloaded, and will then
# re-define all widgets that do completion to use the new system. If you
# use the menu-select widget, which is part of the zsh/complist module,
# you should make sure that that module is loaded before the call to
# compinit so that that widget is also re-defined. If completion styles
# (see below) are set up to perform expansion as well as completion by
# default, and the TAB key is bound to expand-or-complete, compinit will
# rebind it to complete-word; this is necessary to use the correct form
# of expansion.

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# If a completion is performed with the cursor within a word, and a
# full completion is inserted, the cursor is moved to the end of the
# word. That is, the cursor is moved to the end of the word if either a
# single match is inserted or menu completion is performed.
setopt alwaystoend

# If unset, the cursor is set to the end of the word if completion is
# started. Otherwise it stays there and completion is done from both
# ends.
setopt completeinword

# CHANGING DIRECTORIES

# If a command is issued that can’t be executed as a normal command,
# and the command is the name of a directory, perform the cd command to
# that directory. This option is only applicable if the option
# SHIN_STDIN is set, i.e. if commands are being read from standard
# input. The option is designed for interactive use; it is recommended
# that cd be used explicitly in scripts to avoid ambiguity.
setopt autocd

# Make cd push the old directory onto the directory stack.
setopt autopushd

# Don’t push multiple copies of the same directory onto the directory
# stack.
setopt pushdignoredups

# Exchanges the meanings of ‘+’ and ‘-’ when used with a number to
# specify a directory in the stack.
setopt pushdminus

# INPUT/OUTPUT

# If this option is unset, output flow control via start/stop
# characters (usually assigned to ^S/^Q) is disabled in the shell’s
# editor.
setopt noflowcontrol

# Allow comments even in interactive shells.
setopt interactivecomments

# JOB CONTROL

# List jobs in the long format by default.
setopt longlistjobs

# Report the status of background jobs immediately, rather than waiting
# until just before printing a prompt.
setopt notify

# PROMPTING

# If set, parameter expansion, command substitution and arithmetic
# expansion are performed in prompts. Substitutions within prompts do
# not affect the command status.
setopt promptsubst

# EXPANSION AND GLOBBING

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for
# filename generation, etc. (An initial unquoted ‘~’ always produces
# named directory expansion.)
setopt extendedglob

# If a pattern for filename generation has no matches, print an error,
# instead of leaving it unchanged in the argument list. This also
# applies to file expansion of an initial ‘~’ or ‘=’.
setopt nomatch

# ZLE

# Do not beep on error in ZLE.
unsetopt beep

# Selects keymap ‘emacs’ for any operations by the current command, and
# also links ‘emacs’ to ‘main’ so that it is selected by default the
# next time the editor starts.
bindkey -e

# LS

# Use ANSI color sequences to distinguish file types. See LSCOLORS
# below. In addition to the file types mentioned in the -F option some
# extra attributes (setuid bit set, etc.) are also displayed. The
# colorization is dependent on a terminal type with the proper
# termcap(5) capabili- ties. The default ``cons25'' console has the
# proper capabilities, but to display the colors in an xterm(1), for
# example, the TERM variable must be set to ``xterm-color''. Other
# terminal types may require simi- lar adjustments. Colorization is
# silently disabled if the output isn't directed to a terminal unless
# the CLICOLOR_FORCE variable is defined.
export CLICOLOR=1

# Color sequences are normally disabled if the output isn't directed to
# a terminal. This can be overridden by setting this flag. The TERM
# variable still needs to reference a color capable terminal however
# otherwise it is not possible to determine which color sequences to
# use.
export CLICOLOR_FORCE=1

# -l: (The lowercase letter ``ell''.)  List in long format.  (See
# below.)  If the output is to a terminal, a total sum for all the file
# sizes is output on a line before the long listing.
# -A: List all entries except for . and ...  Always set for the
# super-user.
# -h: When used with the -l option, use unit suffixes: Byte, Kilobyte,
# Megabyte, Gigabyte, Terabyte and Petabyte in order to reduce the
# number of digits to three or less using base 2 for sizes.
alias ls='ls -lAh'

# LESS

# -R or --RAW-CONTROL-CHARS: Like -r, but only ANSI "color" escape
# sequences are output in "raw" form. Unlike -r, the screen appearance
# is maintained correctly in most cases. ANSI "color" escape sequences
# are sequences of the form: ESC [ ... m where the "..." is zero or more
# color specification characters For the purpose of keeping track of
# screen appearance, ANSI color escape sequences are assumed to not move
# the cursor. You can make less think that characters other than "m" can
# end ANSI color escape sequences by setting the environment variable
# LESSANSIENDCHARS to the list of characters which can end a color
# escape sequence. And you can make less think that characters other
# than the standard ones may appear between the ESC and the m by setting
# the environment variable LESSANSIMIDCHARS to the list of characters
# which can appear.
alias less='less --RAW-CONTROL-CHARS'


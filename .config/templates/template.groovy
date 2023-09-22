#!/usr/bin/env groovy

/*
    AppName

    Description
*/

@Grapes([
    @Grab(group='info.picocli', module='picocli-groovy', version='4.7.5'),
    @GrabConfi(systemClassLoader=true)
])

@Command(
    name = 'AppName',
    mixinStandardHelpOptions = true,
    description = '@|bold Description|@ @|underline AppName |@ foo'
)

@picocli.groovy.PicocliScript2

package xyz.stewie410.scripts.groovy.appname

import groovy.transform.Field
import static picocli.CommandLine.*

@Option(
    names = ['-c', '--count'],
    description = 'number of repitions'
)
@Field int count = 1;

count.times {
    println 'hi'
}

assert this.CommandLine.commandName = 'AppName'

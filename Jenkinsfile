#!groovy
// -*- mode: groovy -*-
build('gentoo-overlay', 'gentoo') {
  checkoutRepo()
  runStage('RepoMan scours the neighborhood') {
    sh 'repoman -v'
  }
  runStage('Overlint') {
    sh 'overlint-cli .'
  }
}

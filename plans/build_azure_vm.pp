plan boltshop::build_azure_vm(
  Integer $howmany,
  String $location
){

    run_command('cd terraform/azure && terraform init', localhost)

    $task = run_task(
    'terraform::apply',
    localhost,
    var => {
      howmany   => $howmany,
      location  => $location,
    },
    dir => './terraform/azure'
  )

  $task.results[0]['stdout'].split('\n').each |$line| {
    if $line =~ "^Apply complete!" {
      out::message("Terraform: ${line}")
    }
  }

  out::message('Waiting for Azure instances to come alive...')
  wait_until_available('azure')
  get_targets('azure').each | $target | {
    if run_command('hostname', $target).ok {
      out::message("${target} is ready for BoltShop!")
    } else {
      out::message("Something is wrong with ${target}. Please try again.")
    }
  }
}

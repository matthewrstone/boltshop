plan boltshop::destroy_azure_vm(){
  out::message('Destroying resources via Terraform...')
  $task = run_task('terraform::destroy', localhost, dir => './terraform/azure')
  $task.results[0]['stdout'].split('\n').each |$line| {
    if $line =~ "^Destroy complete!" {
      return "Terraform: ${line}"
    }
  }
}

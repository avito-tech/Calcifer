def remote_cache_binary_path
  return "#{Dir.home}/.calcifer.noindex/Calcifer"
end

def remote_cache_is_enabled
  return false unless File.file?(remote_cache_binary_path)
  enabled = %x(#{remote_cache_binary_path} obtainConfigValue --projectDirectory #{Dir.pwd} --keyPath enabled | head -1).to_i
  return enabled == 1
end

def update_remote_cache_if_needed
  return unless remote_cache_is_enabled
  %x(#{remote_cache_binary_path} updateCalcifer --projectDirectory #{Dir.pwd})
end

def create_build_phases_if_needed(target, phase_name, shell, index)
  phase = target.shell_script_build_phases.find { |phase| phase.name && phase.name.end_with?(phase_name) }
  if phase != nil
    if phase.shell_script == shell
      return nil
    else
      phase.shell_script = shell
      phase.show_env_vars_in_log = '0'
      return phase
    end
  end
  phase_class = Xcodeproj::Project::Object::PBXShellScriptBuildPhase
  phase = target.project.new(phase_class).tap do |phase|
    phase.name = phase_name
    phase.shell_script = shell
    phase.show_env_vars_in_log = '0'
  end
  target.build_phases.insert(index, phase)
end

def setup_remote_cache(installer, remote_cache_targets)
  targets_for_patch = Array.new
  user_project = installer.aggregate_targets.first.user_project
  return targets_for_patch if user_project == nil
  user_project.targets.each do |target|
    next unless remote_cache_targets.include?(target.name)
    phase_name = '[Calcifer] Remote Cache'
    shell = [
      "root_path=$(builtin cd $SRCROOT && git rev-parse --show-toplevel)",
      "${root_path}/Avito/Utils/remote_cache.sh"
    ].join("\n")
    resources_index = target.build_phases.find_index { |phase| phase.class == Xcodeproj::Project::PBXResourcesBuildPhase }
    sources_index = target.build_phases.find_index { |phase| phase.class == Xcodeproj::Project::PBXSourcesBuildPhase }
    frameworks_index = target.build_phases.find_index { |phase| phase.class == Xcodeproj::Project::PBXFrameworksBuildPhase }
    phase_index = [resources_index, sources_index, frameworks_index].min
    if phase_index != nil
      create_build_phases_if_needed(target, phase_name, shell, phase_index)
      targets_for_patch << "Pods-#{target.name}"
    end
  end
  return targets_for_patch
end

def unlink_pods_dependencies_for_remote_cache(installer, targets_for_patch)
  if remote_cache_is_enabled
    puts "[Calcifer] Remote cache enabled"
    pods_project = installer.pods_project
    pods_project.targets.each do |target|
      next unless targets_for_patch.include?(target.name)
      new_target_name = target.name + "-Calcifer"
      new_target = pods_project.new_target(target.product_type, new_target_name, target.platform_name, target.deployment_target)
      target.dependencies.each do |dependency|
        new_target.dependencies << dependency
      end
      target.dependencies.clear
    end
  else
    puts "[Calcifer] Remote cache disabled"
  end
end

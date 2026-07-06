import * as projectRepository from '../repositories/project.repository.js'

import type { Project } from '../types/index.js'

export async function getAllProjects(): Promise<Project[]> {
  return projectRepository.findAllProjects()
}

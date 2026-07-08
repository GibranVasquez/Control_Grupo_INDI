import * as projectRepository from '../repositories/project.repository'

import type { Project } from '../types/index'

export async function getAllProjects(): Promise<Project[]> {
  return projectRepository.findAllProjects()
}

export async function getProjectById(id: string): Promise<Project | null> {
  return projectRepository.findProjectById(id)
}

export async function createProject(input: Omit<Project, 'id' | 'created_at'>): Promise<Project> {
  return projectRepository.createProject(input)
}

export async function updateProject(
  id: string,
  input: Partial<Omit<Project, 'id' | 'created_at'>>,
): Promise<Project | null> {
  return projectRepository.updateProject(id, input)
}

export async function deleteProject(id: string): Promise<boolean> {
  return projectRepository.deleteProject(id)
}

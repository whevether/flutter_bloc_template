allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
        maven { url  = uri("https://maven.aliyun.com/repository/public") }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            extensions.configure<com.android.build.gradle.BaseExtension> {
                compileSdkVersion(36)
                buildToolsVersion = "36.0.0"
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }
    layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
    dependencyLocking {
        ignoredDependencies.add("io.flutter:*")
        lockFile = file("${rootProject.projectDir}/project-${project.name}.lockfile")
        if (!project.hasProperty("local-engine-repo")) {
            lockAllConfigurations()
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

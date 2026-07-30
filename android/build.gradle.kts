allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Some older Flutter plugins (e.g. geocoding_android 3.3.1) hardcode compileSdk 33,
// which is incompatible with their newer androidx transitive dependencies that
// require compileSdk 34+. Force every Android subproject up to 36. Reflection keeps
// this independent of the AGP DSL type names, which change across AGP majors.
subprojects {
    val forceCompileSdk = {
        extensions.findByName("android")?.let { androidExt ->
            val setter = androidExt.javaClass.methods.firstOrNull { m ->
                m.name == "setCompileSdk" && m.parameterCount == 1
            }
            if (setter != null) {
                setter.invoke(androidExt, 36)
            } else {
                androidExt.javaClass.methods.firstOrNull { m ->
                    m.name == "compileSdkVersion" && m.parameterCount == 1 &&
                        m.parameterTypes[0] == Integer.TYPE
                }?.invoke(androidExt, 36)
            }
        }
    }
    if (state.executed) {
        forceCompileSdk()
    } else {
        afterEvaluate { forceCompileSdk() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
